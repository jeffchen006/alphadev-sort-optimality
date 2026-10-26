# n=5 model=out iset=I1 prefix14_class=10215
cmp P2, P1
mov S1, P2
cmovle S1, P1
cmovge P2, P1
mov S0, P3
cmp P0, S0
cmovge P3, P0
cmovg P0, S0
cmp P3, S1
cmovle P1, S1
cmovl S1, P3
mov S0, S1
mov S2, P2
cmovle P3, P1
