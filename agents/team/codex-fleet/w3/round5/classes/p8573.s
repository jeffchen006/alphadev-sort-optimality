# n=5 model=out iset=I1 prefix14_class=8573
mov S1, P0
cmp P3, P2
cmovle S0, P3
cmovle P3, P2
cmovle P2, S0
cmp S1, P1
cmovg P0, P1
cmovl S1, P1
mov P1, S1
cmp P1, P3
cmovg P1, P3
cmovl S1, P3
mov S1, P2
cmp S1, P0
