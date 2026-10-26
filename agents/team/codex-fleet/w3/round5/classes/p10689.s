# n=5 model=out iset=I1 prefix14_class=10689
cmp P2, P1
cmovle S1, P1
cmovle P1, P2
cmovl P2, S1
mov S2, P3
cmp S2, P0
cmovg S2, P0
cmovge P0, P3
mov P3, P0
cmp P2, P3
cmovl P3, P2
mov S0, P1
cmovle P2, P0
cmovl P0, P3
