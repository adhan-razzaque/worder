class_name RemovedLetterDisplay
extends Label


func _on_actor_view_struct_changed(actor_view_struct: ActorViewStruct) -> void:
	self.text = ", ".join(actor_view_struct._removed_letters)
