# n=5 model=out iset=I1 prefix14_class=7301
cmp P2, P1
mov S1, P1
cmovle P1, P2
mov S0, P0
cmovle P2, S1
cmp P3, P0
cmovl S0, P3
cmovle P3, P0
mov S2, P1
cmp P1, S0
cmovge P1, S0
mov P1, P2
cmovg S0, S2
mov S1, S0
