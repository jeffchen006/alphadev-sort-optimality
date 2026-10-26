# n=5 model=out iset=I1 prefix14_class=5275
cmp P0, P1
cmovle S0, P1
cmovge S0, P0
cmovg P0, P1
mov P1, P3
cmp P2, P3
cmovl P3, P2
cmovge P1, P2
cmp P0, P3
mov P2, P0
cmovg P2, P3
cmovl P0, P3
cmp S0, P1
cmovge P3, P0
