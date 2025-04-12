<template>
  <v-card>
    <v-tabs
      v-model="tab"
      bg-color="primary"
    >
      <v-tab value="one">Capture</v-tab>
      <v-tab value="two">Result</v-tab>
      <v-tab value="three">Configuration</v-tab>
      <v-tab value="four">GPS</v-tab>
    </v-tabs>

    <v-card-text>
      <v-tabs-window v-model="tab">
        <v-tabs-window-item value="one">
          <TabCapture />
        </v-tabs-window-item>

        <v-tabs-window-item value="two">
          <TabResult />
        </v-tabs-window-item>

        <v-tabs-window-item value="three">
          <TabConfiguration />
        </v-tabs-window-item>

        <v-tabs-window-item value="four">
          <TabGPS />
        </v-tabs-window-item>

      </v-tabs-window>
    </v-card-text>
  </v-card>
</template>
<script>
  export default {
    data: () => ({
      tab: null,
    }),
  }
</script>