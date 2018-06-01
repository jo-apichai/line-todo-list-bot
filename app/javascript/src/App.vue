<template>
  <div id="app">
    <ul>
      <li v-for="task in tasks" :key="task.id">
        {{ task.datetime }} - {{ task.description }}
      </li>
    </ul>
  </div>
</template>

<script>
  import 'whatwg-fetch'

  export default {
    data () {
      return {
        tasks: []
      }
    },

    mounted: function () {
      this.loadTasks()
    },

    methods: {
      loadTasks: function () {
        fetch('/api/v1/tasks', { credentials: 'same-origin' })
          .then((response) => {
            return response.json()
          })
          .then((json) => {
            this.tasks = json
          })
      }
    }
  }
</script>
