# n=5 model=out iset=I1 prefix14_class=7516
cmp P2, P0
cmovle S0, P0
cmovl P0, P2
cmovg S0, P2
mov P2, P3
cmp P1, P2
cmovge P2, P1
cmovg P1, P3
cmp P0, P1
mov S1, P0
cmovle P0, P1
mov S2, P2
cmovl P1, S1
mov P1, P0
