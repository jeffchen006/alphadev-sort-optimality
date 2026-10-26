# n=5 model=out iset=I1 prefix14_class=7556
mov S0, P1
mov S1, P0
cmp P2, P0
cmovg S1, P2
cmovle P0, P2
cmovge P2, P0
cmp P3, S0
cmovg P1, P3
cmovge P3, S0
cmp P0, P3
cmovl P0, P3
cmovle P3, P2
cmp P1, S1
cmovg P2, P0
