# n=5 model=out iset=I1 prefix14_class=8169
mov S2, P3
cmp P3, P2
cmovle S2, P2
cmovle P2, P3
cmp P1, P0
cmovge P3, P1
cmovg P1, P0
cmovge P0, P3
cmp P2, P1
cmovle S1, P2
cmovge S1, P1
cmovl P2, P1
mov S0, P0
cmp P0, S2
