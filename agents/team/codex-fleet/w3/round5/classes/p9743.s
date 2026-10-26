# n=5 model=out iset=I1 prefix14_class=9743
cmp P2, P3
mov S0, P3
mov S1, P0
cmovge P3, P2
cmovle S0, P2
cmp P1, S1
cmovle P0, P1
cmovl P1, S1
cmp P1, P3
cmovge S1, P1
cmovg P1, P3
cmovge P3, S1
mov P3, P1
mov S2, S0
