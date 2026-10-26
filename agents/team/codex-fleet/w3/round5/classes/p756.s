# n=5 model=out iset=I1 prefix14_class=756
cmp P2, P0
mov S1, P1
mov S2, P0
cmovle S2, P2
cmovl P2, P0
cmp S1, P3
cmovl P1, P3
mov S0, P1
cmovg S1, P3
cmp S0, P2
cmovle P1, P2
cmovl P2, S0
mov S0, P2
mov P0, S1
