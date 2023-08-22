({
    doInit: function(component, event, helper) {
        console.log("This value is from child component js controller"+JSON.stringify(component.get("v.kanbanPicklistField")));
        console.log(component.get('v.objName'));
        var action = component.get("c.getKanbanWrap");
        console.log('Line 2');
        action.setParams({
            objName :component.get('v.objName'),
            sfield :component.get('v.kanbanPicklistField')
        })
        console.log('Line 3');
        action.setCallback(this, function(response){
            console.log('line 4');
           
            var temp=[];
            var size=0;
            var state = response.getState();
            var res=response.getReturnValue()
            if (state === "SUCCESS") {
                console.log('line 5');
                
                 for (var m in res) {
                     size=++size;
                    temp.push({ label:m, value:res[m]});
			    }
                
                component.set("v.recordpickval",temp);
                component.set("v.listSize",size);
                console.log("this is recordpickval valueee>>>>>>>>>>>"+JSON.stringify(component.get("v.recordpickval")));
            }
        });
        $A.enqueueAction(action);

    },

    doView: function(component, event, helper) {
        var editRecordEvent = $A.get("e.force:navigateToSObject");
        editRecordEvent.setParams({
            recordId: event.target.id
        });
        editRecordEvent.fire();
    },
    allowDrop: function(component, event, helper) {
        event.preventDefault();													//It prevents the default action of a component. It is called when we are 
        																		//trying to drag a component. By default the prevention icon shows which we are 
        																		//removing
    },
    
    drag: function (component, event, helper) {
        event.dataTransfer.setData("text", event.target.id);
    },
    
    drop: function (component, event, helper) {
        console.log("Drop method is running>>>>>>>>");
        event.preventDefault();													// By default, when you drag an item over a droppable area, the browser attempts 
        																		//to navigate to the URL specified in the dropzone.
        																		// This is because HTML5 drag and drop events are actually mouse events, 
        																		// and the browser is designed to follow links when the mouse button is 
        																		// released over a link.
        																		
        var data = event.dataTransfer.getData("text");							//It brings the data about the element which fired the trigger. Here it is bringing
        																		//the id of the element which is being dragged

        var tar = event.target;													//It brings the context of the element on which the element is dragged or dropped.
        
        while(tar.tagName != 'ul' && tar.tagName != 'UL')						//Tagname is used to get the name of tag which is enclosing the element on which
              	tar = tar.parentElement;										// the element is being dropped. So we are basically using while loop to get the 
            																	// uppermost tag name of the area on which the element is being dropped
          
         console.log('aaaaaaaaaaaaa   :   ' + tar.getAttribute('data-Pick-Val'));
        tar.appendChild(document.getElementById(data));
       
        document.getElementById(data).style.backgroundColor = "#ffb75d";
        helper.updatePickVal(component,data,component.get("v.kanbanPicklistField"),tar.getAttribute('data-Pick-Val'));
        
         
        setTimeout(() => {
         doinit
            
        }, 2000)
        
        
    }
})