
class compiler(object):
	def type_check(self):
		pass

	def uniquify(self):
		pass

	def flatten(self):
		pass

	def expose_alloc(self):
		pass

	def select_instr(self):
		pass

	def uncover_live(self):
		pass

	def build_inter(self):
		pass

	def alloc_reg(self):
		pass

	def assign_home(self):
		self.uncover_live()
		self.build_inter()
		self.alloc_reg()
		pass

	def lower_cond(self):
		pass

	def patch_instr(self):
		pass

	def print_x86(self):
		pass