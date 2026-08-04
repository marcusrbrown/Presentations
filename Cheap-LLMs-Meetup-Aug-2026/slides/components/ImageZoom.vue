<script setup>
import { ref } from 'vue'

defineProps({
  src: { type: String, required: true },
  alt: { type: String, default: '' },
  imgClass: { type: String, default: '' },
})

const open = ref(false)
</script>

<template>
  <img
    :src="src"
    :alt="alt"
    :class="['cursor-zoom-in', imgClass]"
    @click="open = true"
  />
  <Teleport to="body">
    <div
      v-if="open"
      class="fixed inset-0 z-50 bg-black/90 flex items-center justify-center cursor-zoom-out p-2"
      @click="open = false"
    >
      <img :src="src" :alt="alt" class="max-w-[98vw] max-h-[96vh] object-contain" />
    </div>
  </Teleport>
</template>
