
class_name Snake
var body
var direction:Vector2
const width = 40
var is_food_colide
var temp_body

func _init():
	body = [Vector2(width,0),Vector2(0,0)]
	#body[0] is head
	#print(body)
	direction = Vector2(width,0)
	is_food_colide = false

func move():
	if(is_food_colide):
		#Copy of body
		temp_body = body.slice(0,body.size() - 1)
		#print("b", temp_body)
		is_food_colide = false
	else:
		#remove the last item in body
		temp_body = body.slice(0,body.size() - 2)
		#print('b',body, temp_body)
	
	#calculate the new head
	var new_head = temp_body[0] + direction
	#print(temp_body[0], "+", direction ,"=", new_head)
	print(new_head)
	temp_body.insert(0,new_head)
	#print(temp_body)
	body = temp_body

	#direction change - every block occupies the previous position of head
