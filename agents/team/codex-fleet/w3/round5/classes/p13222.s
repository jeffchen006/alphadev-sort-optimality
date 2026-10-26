# n=5 model=out iset=I1 prefix14_class=13222
cmp P0, P1
cmovg S1, P1
cmovge P1, P0
mov S0, P2
cmovg P0, S1
cmp P2, P3
cmovge P2, P3
cmovle S0, P3
cmovle P3, P2
cmp P0, P2
cmovl P2, P0
cmovge P3, P0
cmp P1, S0
mov S2, P3
