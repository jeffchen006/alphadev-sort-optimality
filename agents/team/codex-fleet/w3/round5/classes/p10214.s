# n=5 model=out iset=I1 prefix14_class=10214
cmp P2, P1
mov S2, P2
cmovle S2, P1
cmovge P2, P1
mov S0, P3
cmp P0, S0
cmovge P3, P0
cmovg P0, S0
cmp P3, S2
mov P1, P2
cmovle S1, S2
cmovl S2, P3
cmovle P3, S1
mov S0, S2
