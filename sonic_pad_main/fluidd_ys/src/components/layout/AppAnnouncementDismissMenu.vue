<template>
  <v-menu
    bottom
    left
    offset-y
    transition="slide-y-transition"
    min-width="150"
  >
    <template #activator="{ on, attrs, value }">
      <app-btn
        v-bind="attrs"
        x-small
        v-on="on"
      >
        <v-icon
          x-small
          class="me-1"
        >
          $snooze
        </v-icon>
        {{ $t('app.general.btn.snooze') }}
        <v-icon
          x-small
          class="ms-1"
          :class="{ 'rotate-180': value }"
        >
          $chevronDown
        </v-icon>
      </app-btn>
    </template>
    <v-list dense>
      <v-list-item
        v-for="(preset) of presets"
        :key="preset.delay"
        @click="$emit('dismiss', preset.delay)"
      >
        <v-list-item-icon>
          <v-icon>
            $clock
          </v-icon>
        </v-list-item-icon>
        <v-list-item-content>
          <v-list-item-title>
            {{ preset.label }}
          </v-list-item-title>
        </v-list-item-content>
      </v-list-item>
    </v-list>
  </v-menu>
</template>

<script lang="ts">
import { Component, Mixins } from 'vue-property-decorator'
import StateMixin from '@/mixins/state'

@Component({})
export default class AppAnnouncementDismissMenu extends Mixins(StateMixin) {
  get presets () {
    return [
      {
        label: this.$filters.formatRelativeTime(1, 'hour', { numeric: 'always' }),
        delay: 3600
      },
      {
        label: this.$filters.formatRelativeTime(1, 'day', { numeric: 'always' }),
        delay: 3600 * 24
      },
      {
        label: this.$filters.formatRelativeTime(7, 'day', { numeric: 'always' }),
        delay: 3600 * 24 * 7
      }
    ]
  }
}
</script>
