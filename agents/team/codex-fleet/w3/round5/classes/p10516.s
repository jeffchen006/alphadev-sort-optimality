# n=5 model=out iset=I1 prefix14_class=10516
cmp P3, P2
mov S2, P3
mov S0, P0
cmovle S2, P2
cmovg P3, P2
cmp P1, S0
cmovge P0, P1
cmovge P1, S0
cmp P0, S2
cmovle P2, S2
cmovle S2, P0
cmovl P0, P2
mov S1, P1
mov P0, S2
