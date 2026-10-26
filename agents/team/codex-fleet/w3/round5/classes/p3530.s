# n=5 model=out iset=I1 prefix14_class=3530
cmp P3, P2
mov S0, P1
mov S2, P2
cmovge P2, P3
cmovge P3, S2
cmp P1, P0
cmovl P1, P0
cmovle P0, S0
cmp P0, P3
mov S2, P3
cmovle S2, P0
mov S2, P1
cmovg P3, P0
cmp P2, P1
