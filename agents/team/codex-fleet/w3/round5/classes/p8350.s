# n=5 model=out iset=I1 prefix14_class=8350
cmp P0, P3
cmovle S0, P3
cmovl P3, P0
cmovle P0, S0
mov S2, P1
cmp P2, P1
cmovge P1, P2
cmovg P2, S2
mov S1, P2
cmp P2, P3
cmovg P2, P3
cmovle S1, P3
cmp P1, P0
mov P2, S1
