# n=5 model=out iset=I1 prefix14_class=7589
cmp P3, P0
cmovg S0, P0
cmovge P0, P3
cmovle S0, P3
cmp P1, P2
mov S1, P2
cmovle S1, P1
cmovl P1, P2
cmp S0, S1
cmovl P3, S0
cmovle S0, S1
cmovl S1, P3
cmp P0, P1
cmovge P3, P0
