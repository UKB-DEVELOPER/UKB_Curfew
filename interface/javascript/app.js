const { createApp } = Vue;

createApp({
  data() {
    return { 
        showBoxAnnounce:false,
        NotifyAnnounce:[],
        type:'',
        title:'',
        showItemAnnounce:false,
    };
  },
  methods: {
    getData() {
      window.addEventListener("message", (event) => {
        if (event.data) {
          if (event.data.showBoxAnnounce != null && event.data.showBoxAnnounce != undefined && event.data.showBoxAnnounce != '') {
            this.showBoxAnnounce = event.data.showBoxAnnounce;
            this.type = event.data.type;
          }
          
          if (event.data.action == 'addAnn') {
            this.AddNotify(event.data.type,event.data.title,event.data.id)
          }

          if (event.data.action == 'removeAnn') {
            this.RemoveNotify(event.data.index)
          }

        }
      });
    },
    onkeydown (){
      window.addEventListener("keydown", (event) => {
        if (event.key == 'Escape') {
          this.CloseUI()
        }
      });
    },
    AddNotify(type,title,id){
      this.NotifyAnnounce.push({type:type,title:title,id:id})
    },
    RemoveNotify(index){
         this.NotifyAnnounce.map((item,i) => {
            if (index == item.id) {
              this.NotifyAnnounce.splice(i,1)
            }
         })
    },
    RemoveNotifyToBackend(id){
      fetch(`https://${GetParentResourceName()}/RemoveAnnounceCurfew`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ index:id}),
      });
    },
    Notify(type,message){
      fetch(`https://${GetParentResourceName()}/Notify`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ type:type,message:message}),
      });
    },
    async AnnounceCurfew(){
      if (this.type == '' || this.type == null || this.title == '' || this.title == null) {
          this.Notify('warning','กรุณากรอกข้อมูลให้ครบ!!')
          return;
      }
      await fetch(`https://${GetParentResourceName()}/AddAnnounceCurfew`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ title:this.title,type:this.type}),
      });
      this.CloseUI()
    },
    ChangeType(type){
      this.type = type;
      if (type == 'curfew'){
        this.title = ''
      }
    },
    CloseUI(){
        this.showBoxAnnounce = false;
        this.title = '';
        this.type = '';
        this.showItemAnnounce = false;
        fetch(`https://${GetParentResourceName()}/CloseUI`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({}),
      });
    }
  },
  watch: {
    type(){
      if (this.type == 'rampage') {
        this.title = 'มาตรการสูงสุด'
      }
    }

  },
  async mounted() {
    await this.getData();
    await this.onkeydown();
  }
}).mount("#app");
