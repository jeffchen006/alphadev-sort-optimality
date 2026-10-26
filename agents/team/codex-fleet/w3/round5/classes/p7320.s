# n=5 model=out iset=I1 prefix14_class=7320
mov S2, P2
cmp P2, P0
cmovl P2, P0
cmovle P0, S2
mov S2, P2
mov S0, P3
cmp P3, P1
cmovle S0, P1
cmovge P3, P1
cmp P3, P0
cmovge P1, P3
cmovg P3, P0
cmovge P0, P1
cmp P2, S0
