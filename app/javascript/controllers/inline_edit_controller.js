import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

    static targets = ["groupTitle", "inlineEditForm"]
    connect() {
        console.log("Expense show controller is active")
        this.groupTitle = this.groupTitleTarget;
        this.inlineEditTemplate = this.inlineEditFormTarget;
        this.editting = false;
        this.oldChild = null;
    }

    doubleClick(event) {
        if (!this.editting) {
            console.log("Double clicked")
            this.oldChild = this.groupTitle.firstChild;
            const newNode = this.inlineEditTemplate.content.cloneNode(true)
            this.groupTitle.replaceChild(newNode, this.oldChild);
            this.editting = true;
        }
    }

    cancelEdit(event) {
        if (event.key === "Meta" || event.key === "Escape") {
            console.log(this.groupTitle);
            const oldNode = this.oldChild.cloneNode(true);
            this.groupTitle.innerHTML = "";
            this.groupTitle.appendChild(oldNode);
            this.editting = false;
            this.oldChild = null;
        }
    }
}

