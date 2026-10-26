# n=5 model=out iset=I1 prefix14_class=10733
mov S2, P3
cmp P3, P2
cmovle P3, P2
cmovge S2, P2
cmp P1, P0
mov P2, S2
cmovle S1, P1
mov S0, P3
cmovle P1, P0
cmovl P0, S1
cmp P1, P3
cmovge P3, P1
cmovge P1, S0
mov P3, P1
