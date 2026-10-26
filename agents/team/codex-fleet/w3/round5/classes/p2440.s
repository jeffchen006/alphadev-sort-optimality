# n=5 model=out iset=I1 prefix14_class=2440
mov S0, P2
cmp S0, P1
cmovle S0, P1
cmovg P2, P1
mov P1, P3
cmp P0, P1
cmovge P3, P0
cmovg P0, P1
cmovg P1, P3
cmp P1, S0
cmovle P1, S0
cmovl S0, P3
cmp P2, P0
cmovle S1, P0
