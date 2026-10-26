# n=5 model=out iset=I1 prefix14_class=11598
cmp P0, P3
mov S0, P0
cmovl P0, P3
cmovg S0, P3
mov P3, P2
cmp P3, P1
cmovle P3, P1
cmovg P2, P1
cmp S0, P2
mov P1, P0
cmovle S1, P2
cmovl P2, S0
cmovl S0, S1
mov P2, S0
