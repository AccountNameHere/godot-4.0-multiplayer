extends Node

# For some reason, the MultiplayerSynchronizer doesn't work if it is assigned to the scene's root,
# therefore we use a workaround of making a Node that keeps track of the data needed to be transfered.

# Here we only need the position to be synced
@export var pos = Vector3(0, 2, 0)
