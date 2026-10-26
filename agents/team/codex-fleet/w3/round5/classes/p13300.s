# n=5 model=out iset=I1 prefix14_class=13300
cmp P0, P2
cmovle S1, P0
cmovle P0, P2
cmovle P2, S1
mov S0, P3
cmp P1, P3
cmovl P3, P1
cmovle P1, S0
mov S2, P3
cmp P3, P2
cmovge P3, P2
cmovge P2, S2
mov S2, P0
cmp P0, P1
