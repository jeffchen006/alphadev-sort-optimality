# n=5 model=out iset=I1 prefix14_class=8784
mov S0, P3
mov S2, P2
cmp P0, P2
cmovle P2, P0
cmovl P0, S2
cmp P1, S0
cmovle S0, P1
cmovge P3, P1
cmp P0, P3
cmovge P1, P0
cmovg P0, P3
cmovg P3, P1
mov S2, P2
cmp P2, S0
