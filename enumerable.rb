module Enumerable

	def my_each

		arr_res = self.to_a

		if block_given?
			for i in (0..arr_res.length-1) do
				yield(arr_res[i])
			end
		else
			arr_res.to_enum
		end

	end

	def my_each_with_index(*args)

		args.length == 0 ? num_elems = self.length-1 : num_elems = args[0]-1 
		if block_given?
			for i in (0..num_elems) do
				yield(self[i],i)
			end
		else
			res =[]
			for i in (0..num_elems) do
				res << self[i]
			end
			res.to_enum
		end

	end

	def my_select
		arr_res = []

		if block_given?
			self.my_each do |item|
				if yield(item)
						arr_res << item
				end
			end
		else
			arr_res = self.to_enum
		end

		return(arr_res)

	end

	def my_all?
		res = true

		for i in (0..self.length-1) do

			if self[i] == nil
				res = false
				break
			elsif block_given?

				if !yield(self[i])
					res = false
					break
				end
			end
		end

		return(res)
	end

	def my_any?
		res = false

		for i in (0..self.length-1) do

			if block_given?
				if yield(self[i])
					res = true
					break
				end
			elsif self[i]
				res = true
				break
			end
		end

		return(res)
	end

	def my_none?
		res = false

		if block_given?
			res = self.my_all? {|x| yield(x) == false}
		else
			res = self.my_all? {|x| x == false}
		end

		return res
	end

	def my_count(*item)
		res = []

		if block_given?
			res = self.my_select {|x| yield(x)}
		elsif !item.empty?
			res = self.my_select {|x| x == item[0]}
		else
			res = self
		end

		return res.length
	end

	def my_map(&code_block)
		res = []

		if code_block
			res = self.my_select {|x| code_block.call(x)}
		elsif block_given?
			res = self.my_select {|x| yield(x)}
		else
			res = self.my_select
		end

		return res

	end

	def my_inject(*args)

		args_size = args.length
		arr_res = self.to_a

		if block_given?

				args_size == 0 ? memo = arr_res[0] : memo = args[0]

				self.my_each {|item| memo = yield(memo,item)}

		elsif args_size == 1

				if args[0] == :+
					arr_res[0].is_a?(String) ? memo = "" : memo = 0
				else
					arr_res[0].class != arr_res[1].class ? memo = arr_res[0] : memo = 1
				end

				arr_res.my_each {|item| memo = memo.method(args[0]).call item if item.is_a?(Integer) || (args[0] == :+)}

		elsif args_size == 2
			arr_res.my_each {|item| memo = memo.method(args[1]).call item}

		end

		return memo
	end

end

def multiply_els(arr)
	arr.my_inject(:*)
end



#Test


print "\n\n Testing my_map \n"
p (1..4).map { |i| i*i }

print "\n\n Testing multiply and my_inject\n"
p multiply_els([1,2,3,4,])
p multiply_els((1..4))
p ["now",3].my_inject(:*)
p (5..10).my_inject { |sum, n| sum + n }

a = %w{ a b c d e f }
p a.my_inject(:+)
