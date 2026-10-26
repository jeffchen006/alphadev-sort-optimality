# n=5 model=out iset=I1 prefix14_class=12764
mov S1, P1
cmp P1, P0
cmovle S1, P0
cmovge P1, P0
cmp P3, P2
cmovle P0, P2
cmovl P2, P3
mov S2, P1
cmovle P3, P0
cmp P2, S2
cmovge P1, P2
cmovg P2, S2
cmp P3, S1
mov S0, S1
