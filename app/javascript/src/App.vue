<template>
  <div id="app">
    <ul class="list-group">
      <li v-for="(task, index) in tasks" :key="task.id"
        class="list-group-item"
        v-bind:class="{ finished: task.finished }">
        <input type="checkbox" name="finished"
          v-model="task.finished"
          v-on:click="toggleFinished($event, task.id, index)">
        {{ task.datetime }} - {{ task.description }}
      </li>
    </ul>
  </div>
</template>

<script>
  import { restRequest } from '../utilities/restRequest'

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
      loadTasks: async function () {
        const data = await restRequest('/tasks')
        this.tasks = data
      },

      toggleFinished: async function (event, id, index) {
        const task = {
          finished: event.target.checked
        }

        const data = await restRequest(`/tasks/${id}`, {
          method: 'PATCH',
          body: JSON.stringify({ task })
        })

        this.$set(this.tasks, index, data)
      }
    }
  }
</script>
