// Commands for sending messages on a UART bus
//
// Copyright (C) 2021  Desuuuu <contact@desuuuu.com>
//
// This file may be distributed under the terms of the GNU GPLv3 license.

#include <string.h> // memcpy
#include "basecmd.h" // oid_alloc
#include "command.h" // DECL_COMMAND
#include "sched.h" // DECL_SHUTDOWN
#include "board/serial_irq.h" //serial_prepare/send

struct uartdev_s {
    uint8_t id, rx_buf, tx_buf, ready;
    uint16_t rx_interval;
};

int_fast8_t uart_process(uint8_t id, uint8_t* data, uint_fast8_t len
                         , uint_fast8_t *pop_count);

void
command_config_uart(uint32_t *args)
{
    struct uartdev_s *uart = oid_alloc(args[0], command_config_uart,
                                       sizeof(*uart));
    uart->rx_buf = args[1];
    uart->tx_buf = args[2];
    uart->rx_interval = args[3];
    uart->ready = 0;
}
DECL_COMMAND(command_config_uart,
             "config_uart oid=%c rx_buffer=%c tx_buffer=%c rx_interval=%hu");

struct uartdev_s *
uartdev_oid_lookup(uint8_t oid)
{
    return oid_lookup(oid, command_config_uart);
}

void
command_uart_set_bus(uint32_t *args)
{
    struct uartdev_s *uart = uartdev_oid_lookup(args[0]);
    if (uart->ready)
        shutdown("Invalid UART config");
    uart->ready = 1;
    uart->id = serial_prepare(args[1], args[2], uart->rx_buf, uart->tx_buf,
                              uart->rx_interval, &uart_process);
}
DECL_COMMAND(command_uart_set_bus, "uart_set_bus oid=%c uart_bus=%c baud=%u");

void
command_uart_send(uint32_t *args)
{
    struct uartdev_s *uart = uartdev_oid_lookup(args[0]);
    if (!uart->ready)
        return;
    uint8_t data_len = args[1];
    uint8_t *data = command_decode_ptr(args[2]);
    serial_send(uart->id, data, data_len);
}
DECL_COMMAND(command_uart_send, "uart_send oid=%c data=%*s");

int_fast8_t
uart_process(uint8_t id, uint8_t* data, uint_fast8_t len
             , uint_fast8_t *pop_count)
{
    uint8_t oid;
    struct uartdev_s *uart;
    foreach_oid(oid, uart, command_config_uart) {
        if (uart->id != id)
            continue;
        if (!sendf("uart_receive oid=%c data=%*s", oid, len, data))
            return 0;
        break;
    }
    *pop_count = len;
    return 1;
}

/****************************************************************
 * Shutdown handling
 ****************************************************************/

struct uartdev_shutdown_s {
    struct uartdev_s *uart;
    uint8_t shutdown_msg_len;
    uint8_t shutdown_msg[];
};

void
command_config_uart_shutdown(uint32_t *args)
{
    struct uartdev_s *uart = uartdev_oid_lookup(args[1]);
    uint8_t shutdown_msg_len = args[2];
    struct uartdev_shutdown_s *sd = oid_alloc(
        args[0], command_config_uart_shutdown,
        sizeof(*sd) + shutdown_msg_len);
    sd->uart = uart;
    sd->shutdown_msg_len = shutdown_msg_len;
    uint8_t *shutdown_msg = command_decode_ptr(args[3]);
    memcpy(sd->shutdown_msg, shutdown_msg, shutdown_msg_len);
}
DECL_COMMAND(command_config_uart_shutdown,
             "config_uart_shutdown oid=%c uart_oid=%c shutdown_msg=%*s");

void
uartdev_shutdown(void)
{
    uint8_t oid;
    struct uartdev_shutdown_s *sd;
    foreach_oid(oid, sd, command_config_uart_shutdown) {
        if (!sd->uart->ready)
            continue;
        serial_send(sd->uart->id, sd->shutdown_msg, sd->shutdown_msg_len);
    }
}
DECL_SHUTDOWN(uartdev_shutdown);
