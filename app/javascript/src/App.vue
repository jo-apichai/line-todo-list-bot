<template>
  <div id="app">
    <ul class="list-group">
      <li v-for="(task, index) in tasks" :key="task.id"
        class="list-group-item"
        v-bind:class="{ finished: task.finished }">

        <i class="fas fa-star" v-bind:class="{ active: task.important }"
          v-on:click="toggleImportant($event, task.id, index)"></i>

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
      },

      toggleImportant: async function (event, id, index)  {
        const important = !event.target.classList.contains('active')
        const task = { important }

        const data = await restRequest(`/tasks/${id}`, {
          method: 'PATCH',
          body: JSON.stringify({ task })
        })

        if (important) {
          this.tasks.splice(index, 1)
          this.tasks.unshift(data)
        } else {
          this.$set(this.tasks, index, data)
        }
      }
    }
  }
</script>
