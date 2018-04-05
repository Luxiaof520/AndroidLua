test = bin.androidlua.TestObject()

print("test.getMessage()")
msg = test.getMessage()
print("test.message")
msg = test.message

print('test.setMessage("123456789")')
test.setMessage("123456789")
print('test.message = "987654321"')
test.message = "987654321"
