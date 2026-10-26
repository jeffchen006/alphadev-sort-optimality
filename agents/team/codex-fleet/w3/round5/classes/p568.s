# n=5 model=out iset=I1 prefix14_class=568
cmp P0, P2
mov S2, P0
cmovge P0, P2
cmovg P2, S2
cmp P1, P3
cmovge S0, P1
cmovle S0, P3
cmovg P1, P3
mov P3, P0
cmp P1, P3
cmovg P0, P1
cmovle P3, P1
mov P1, S0
cmp P2, S0
