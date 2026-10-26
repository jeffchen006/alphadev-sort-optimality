# n=5 model=out iset=I1 prefix14_class=8691
cmp P3, P0
mov S1, P3
cmovg S1, P0
cmovl P3, P0
cmp P2, P1
cmovle S0, P1
cmovl P1, P2
cmovle P2, S0
cmp P3, P2
mov P0, P3
cmovle P0, P2
cmovle P2, P3
cmp S1, P1
mov P3, S1
