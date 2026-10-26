# n=5 model=out iset=I1 prefix14_class=8993
mov S0, P2
cmp P1, P0
cmovg S1, P0
cmovg P0, P1
cmovg P1, S1
cmp P2, P3
cmovle P2, P3
cmovg S0, P3
cmp P0, P2
cmovge P3, P2
cmovge P2, P0
cmovl P3, P0
mov P2, P1
cmp P1, S0
