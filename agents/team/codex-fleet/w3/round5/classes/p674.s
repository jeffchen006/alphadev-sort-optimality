# n=5 model=out iset=I1 prefix14_class=674
cmp P3, P2
mov S0, P2
cmovl P2, P3
mov S1, P1
cmovle P3, S0
cmovg S0, P3
cmp S1, P0
cmovg P1, P0
cmovl S1, P0
cmp P3, S1
cmovl S0, S1
cmovle S1, P3
mov P3, P2
cmp P2, P1
