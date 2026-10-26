# n=5 model=out iset=I1 prefix14_class=9747
cmp P0, P2
mov S0, P0
cmovge S0, P2
cmovg P2, P0
cmp P3, P1
cmovle S1, P1
cmovle P1, P3
cmovle P3, S1
cmp P3, P2
cmovg P0, P3
cmovge P3, P2
cmovg P2, P0
mov S2, S0
mov S1, P3
