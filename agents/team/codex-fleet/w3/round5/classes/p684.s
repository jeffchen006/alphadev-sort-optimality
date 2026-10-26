# n=5 model=out iset=I1 prefix14_class=684
mov S0, P0
cmp P1, P0
cmovle S0, P1
cmovl P1, P0
mov S2, P3
cmp S2, P2
cmovg S2, P2
cmovl P3, P2
mov P0, P1
cmp P1, P3
cmovl P1, P3
cmovl P3, P0
mov P0, S0
cmp S0, S2
