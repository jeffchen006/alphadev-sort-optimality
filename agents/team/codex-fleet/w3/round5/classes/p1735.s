# n=5 model=out iset=I1 prefix14_class=1735
mov S0, P1
cmp P1, P0
cmovl P1, P0
mov S2, P1
cmovle P0, S0
cmp P3, P2
cmovle S0, P2
cmovl P2, P3
cmovle P3, S0
mov S1, P0
cmp P2, P0
cmovg S1, P2
cmovge P2, P0
cmp P3, P1
