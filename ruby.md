# 1. How do you calculate the power of a number?

-> Exponents can be calculated using the ** operator
```ruby
5 ** 2
```

-> This operator does the same than:

```ruby
def pow(base,exponent)
	power = 1
	for index in 1..exponent
		power = power * base
	end

	return power
end
```

# 2. Write a ruby method that returns the even numbers from an array of float numbers.
(Do not use the even ruby method)

```ruby
array_of_floats = [2.0, 3.0, 4.0, 5.0, 6.0, 7.0]

array_of_floats.map { |number| (number % 2).zero? }.compact
```

# 3. What are collection and member routes?
:member is used when a route has a unique field :id or :slug and

```ruby
Rails.application.routes.draw do
	resources :homes do
 		get :post, on: :collection
	end
end
```
=> post_home  GET   /homes/:id/post(.:format) homes#post

:collection is used when there is no unique field required in the route.

```ruby
Rails.application.routes.draw do
	resources :homes do
 		get :post, on: :member
	end
end
```
=> post_homes  GET    /homes/post(.:format)  homes#post

# 4. What is polymorphism?
This term refers to have multiple froms, The idea is that the common method reveals and expresses itself in the many different (class) forms or objects it inhab

# 5. What is the purpose of object private methods?
The principal object of private methods is Allow to encapsulate our methods therefore abstract some logic thus applying important concepts of OOP.