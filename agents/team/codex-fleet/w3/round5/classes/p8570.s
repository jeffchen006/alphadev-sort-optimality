# n=5 model=out iset=I1 prefix14_class=8570
cmp P3, P1
cmovle S1, P3
cmovl P3, P1
cmovl P1, S1
mov S0, P2
cmp S0, P0
cmovg P2, P0
cmovle S0, P0
cmovg P0, S0
cmp P0, P3
cmovge P0, P3
cmovle S0, P3
mov P3, P2
cmp P3, P1
