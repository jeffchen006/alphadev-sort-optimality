# n=5 model=out iset=I1 prefix14_class=1255
cmp P3, P2
cmovle S2, P2
cmovl P2, P3
cmovg S2, P3
cmp P1, P0
cmovge S0, P1
cmovl S0, P0
cmovl P0, P1
mov P3, S0
cmp S2, S0
cmovl S0, S2
mov P1, P2
cmovge P3, S2
cmovge S2, S0
