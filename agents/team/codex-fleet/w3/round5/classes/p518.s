# n=5 model=out iset=I1 prefix14_class=518
mov S2, P2
cmp P3, P1
mov S1, P3
cmovge S1, P1
cmovg P1, P3
cmp P2, P0
cmovge P2, P0
cmovg P0, S2
mov S0, P1
mov S2, S1
cmp P2, S2
cmovle S1, P2
cmovg S2, P2
cmovle P2, S2
