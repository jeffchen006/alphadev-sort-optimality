# n=5 model=out iset=I1 prefix14_class=6762
mov S0, P0
cmp P1, P3
mov S2, P3
cmovl S2, P1
cmovle P1, P3
cmp P0, P2
cmovg S0, P2
cmovle P0, P2
cmp P0, P1
cmovg S1, P0
cmovge P0, P1
cmovg P1, S1
mov P3, S0
mov P2, P0
