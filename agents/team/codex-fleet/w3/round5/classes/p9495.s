# n=5 model=out iset=I1 prefix14_class=9495
cmp P0, P3
cmovle S0, P0
cmovl P0, P3
mov S1, P2
cmovle P3, S0
cmp P1, P2
cmovg P2, P1
cmovle S1, P1
cmovge P1, S1
cmp P1, P3
cmovle S1, P3
cmovg P1, P3
mov P1, P2
cmp P0, P2
