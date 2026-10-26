# n=5 model=out iset=I1 prefix14_class=7815
cmp P0, P2
mov S1, P2
cmovle P2, P0
cmovg S1, P0
cmp P3, P1
cmovg S0, P1
cmovge P1, P3
cmovle S0, P3
cmp S0, P2
cmovl P0, P2
cmovle P2, S0
mov P3, S1
cmovl S0, P0
cmp S1, P1
