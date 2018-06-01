<template>
  <div id="app">
    <div class="list-group">
      <draggable v-model="tasks" :move="checkMove">
        <div v-for="(task, index) in tasks" :key="task.id"
          class="list-group-item"
          v-bind:class="{ finished: task.finished, important: task.important }">

          <i class="fas fa-star" v-bind:class="{ active: task.important }"
            v-on:click="toggleImportant($event, task.id, index)"></i>

          <input type="checkbox" name="finished"
            v-model="task.finished"
            v-on:click="toggleFinished($event, task.id, index)">

          {{ task.datetime }} - {{ task.description }}
        </div>
      </draggable>
    </div>
  </div>
</template>

<script>
  import draggable from 'vuedraggable'
  import { restRequest } from '../utilities/restRequest'

  export default {
    components: {
      draggable,
    },

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
          this.tasks.splice(index, 1)
          this.tasks.push(data)
        }
      },

      checkMove: function (event) {
        return !(
          event.related.classList.contains('important') ||
          event.dragged.classList.contains('important')
        )
      }
    }
  }
</script>
