# n=5 model=out iset=I1 prefix14_class=4092
mov S0, P2
mov S1, P0
cmp P3, S0
cmovle P2, P3
cmovge S0, P3
cmp P1, S1
cmovge P0, P1
cmovge P1, S1
mov S2, P1
cmp P2, S2
cmovg P1, P2
cmovg P2, S2
cmp P0, S0
cmovle S1, S0
