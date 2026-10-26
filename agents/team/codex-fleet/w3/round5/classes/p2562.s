# n=5 model=out iset=I1 prefix14_class=2562
mov S1, P2
cmp P2, P0
cmovl P2, P0
cmovle P0, S1
cmp P3, P1
mov S0, P1
cmovg P1, P3
cmovge P3, S0
cmp P2, P1
cmovle S2, P1
cmovg S2, P2
cmovge P2, P1
mov S0, P2
cmp P0, P3
